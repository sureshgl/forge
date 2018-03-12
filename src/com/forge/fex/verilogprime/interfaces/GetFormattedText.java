package com.forge.fex.verilogprime.interfaces;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.fex.verilogprime.ext.AbstractBaseExt;
import com.forge.fex.verilogprime.utils.ExtendedContextVisitor;

import lombok.Data;

public abstract class GetFormattedText {

	abstract public ParserRuleContext getContext();

	protected static final Logger L = LoggerFactory.getLogger(GetFormattedText.class);
	private ExtendedContextVisitor extendedContextVisitor;

	public GetFormattedText() {
		extendedContextVisitor = new ExtendedContextVisitor();
	}

	public AbstractBaseExt getExtendedContext(ParseTree context) {
		if (context != null) {
			return extendedContextVisitor.visit(context);
		} else {
			GetFormattedText.L.warn("Returning Null for extendedContext");
			return null;
		}
	}

	public String getFormattedText() {
		StringBuilder sb = new StringBuilder();
		Params params = new Params(getContext(), sb);
		params.setBeginingOfAlignemtText(getContext().start.getStartIndex());
		getFormattedText(params);
		// L.debug("output =\n" + sb.toString());
		return sb.toString().trim();

	}

	protected void getFormattedText(Params params) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (childCtx instanceof TerminalNode) {
					printTerminalNode((TerminalNode) childCtx, params);
				} else if (childCtx.getText().length() > 0) {
					params.setContext((ParserRuleContext) childCtx);
					Params thisCtxParams = getExtendedContext(childCtx).getUpdatedParams(params);
					getExtendedContext(childCtx).getFormattedText(thisCtxParams);
				}
			}
		}
	}

	@Data
	protected class Params {
		public Params(ParserRuleContext ctx, StringBuilder sb) {
			this.context = ctx;
			beginingOfAlignemtText = 0;
			input = ctx.start.getInputStream();
			this.stringBuilder = sb;
		}

		private ParserRuleContext context;
		private CharStream input;
		private StringBuilder stringBuilder;
		private int beginingOfAlignemtText;

		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();

			sb.append("Context = " + context.getClass().getSimpleName() + "\n" + context.getText());
			sb.append("\n");
			sb.append("Text = " + stringBuilder.toString());
			sb.append("\n");
			sb.append("start =" + beginingOfAlignemtText);
			sb.append("\n");
			return sb.toString();
		}

	}

	/*
	 * check if they are pointing to the same char stream, else it resets the params
	 * with the new char stream params.
	 */
	protected Params getUpdatedParams(Params params) {

		if (getContext() == null) {
			// The item is removed during the transformation, hence skip its contents.
			String alignmentText = params.getInput().getText(
					new Interval(params.beginingOfAlignemtText, params.getContext().start.getStartIndex() - 1));
			params.getStringBuilder().append(alignmentText);
			params.setBeginingOfAlignemtText(params.getContext().stop.getStopIndex() + 1);
			return null;
		}
		if (getContext().start.getInputStream() != params.getContext().start.getInputStream()) {
			/*
			 * advance the begining of alignment text, as we are going to consider
			 * 'mostRecentContext' in its place.
			 */
			if (params.beginingOfAlignemtText < params.getContext().start.getStartIndex()) {
				String alignmentText = params.getInput().getText(
						new Interval(params.beginingOfAlignemtText, params.getContext().start.getStartIndex() - 1));
				params.getStringBuilder().append(alignmentText);
			}
			params.setBeginingOfAlignemtText(params.getContext().stop.getStopIndex() + 1);
			return new Params(getContext(), params.getStringBuilder());
		} else {
			params.setContext(getContext());
			return params;
		}
	}

	private void printTerminalNode(TerminalNode node, Params params) {
		CharStream input = params.getContext().start.getInputStream();
		if (node.getText().equals("<EOF>")) {
			String end = input.getText(new Interval(params.getBeginingOfAlignemtText(), input.size()));
			params.getStringBuilder().append(end);
		} else {
			if (params.getBeginingOfAlignemtText() < node.getSymbol().getStartIndex()) {
				Interval alignmentTextInterval = new Interval(params.getBeginingOfAlignemtText(),
						node.getSymbol().getStartIndex() - 1);
				String alignmentText = input.getText(alignmentTextInterval);
				params.getStringBuilder().append(alignmentText);
			}
			params.getStringBuilder().append(node.getText());
			params.setBeginingOfAlignemtText(node.getSymbol().getStopIndex() + 1);
		}
	}

}

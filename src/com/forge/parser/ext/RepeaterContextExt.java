package com.forge.parser.ext;

import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.RepeaterContext;

public class RepeaterContextExt extends AbstractBaseExt {

	public RepeaterContextExt(RepeaterContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RepeaterContext getContext() {
		return (RepeaterContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).repeater());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RepeaterContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RepeaterContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void requiredPropertyCheck() {
		RepeaterContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		propStore.put("propName", ctx.repeater_identifier().extendedContext.getFormattedText());
		for (int i = 0; i < ctx.repeater_properties().size(); i++) {
			ctx.repeater_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("wires")) {
			throw new IllegalStateException("In repeater " + ctx.repeater_identifier().extendedContext.getFormattedText()
					+ " wire not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("flop")) {
			new IllegalStateException("In repeater " + ctx.repeater_identifier().extendedContext.getFormattedText()
					+ " flop not present in line " + ctx.start.getLine());
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		RepeaterContext ctx = getContext();
		String name = ctx.repeater_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In Repeater duplicate block with name " + name + " exists in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
	}

	@Override
	public void getIdentifier(List<String> idList) {
		RepeaterContext ctx = getContext();
		idList.add(ctx.repeater_identifier().extendedContext.getFormattedText());
	}
}

package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Source_textContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Source_textContextExt extends AbstractBaseExt {

	public Source_textContextExt(Source_textContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Source_textContext getContext() {
		return (Source_textContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).source_text());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Source_textContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Source_textContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
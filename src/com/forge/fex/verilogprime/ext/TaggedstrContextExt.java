package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TaggedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TaggedstrContextExt extends AbstractBaseExt {

	public TaggedstrContextExt(TaggedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TaggedstrContext getContext() {
		return (TaggedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).taggedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TaggedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TaggedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
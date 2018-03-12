package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Attribute_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Attribute_instanceContextExt extends AbstractBaseExt {

	public Attribute_instanceContextExt(Attribute_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Attribute_instanceContext getContext() {
		return (Attribute_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).attribute_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Attribute_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Attribute_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
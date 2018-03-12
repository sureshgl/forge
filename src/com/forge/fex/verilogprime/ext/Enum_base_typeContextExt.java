package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Enum_base_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Enum_base_typeContextExt extends AbstractBaseExt {

	public Enum_base_typeContextExt(Enum_base_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Enum_base_typeContext getContext() {
		return (Enum_base_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enum_base_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Enum_base_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Enum_base_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}